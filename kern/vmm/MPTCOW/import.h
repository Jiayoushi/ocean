#ifndef _KERN_VMM_MPTCOW_H_
#define _KERN_VMM_MPTCOW_H_

#ifdef _KERN_

void copy_pdir_entry(unsigned int from, unsigned int to, unsigned int pde);

#endif  /* _KERN_ */

#endif  /* !_KERN_VMM_MPTCOW_H_ */
