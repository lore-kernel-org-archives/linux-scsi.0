From: Steven Dake <sdake@mvista.com>
Subject: SCSI won't compile with PROC enabled on 2.6.0-test5
Date: Wed, 24 Sep 2003 11:57:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064429833.13033.316.camel@persist.az.mvista.com>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:28221 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S261613AbTIXS5P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 14:57:15 -0400
Received: from persist.az.mvista.com (persist.az.mvista.com [10.50.1.87])
	by zipcode.az.mvista.com (8.9.3/8.9.3) with ESMTP id MAA25022
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2003 12:13:41 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The compile result is:

  CC      drivers/scsi/scsi_syms.o
  CC      drivers/scsi/scsi_sysfs.o
  CC      drivers/scsi/scsi_devinfo.o
  CC      drivers/scsi/scsi_proc.o
drivers/scsi/scsi_proc.c:80: parse error before "do"
drivers/scsi/scsi_proc.c:85: parse error before '&' token
drivers/scsi/scsi_proc.c:85: warning: type defaults to `int' in
declaration of `down'
drivers/scsi/scsi_proc.c:85: warning: function declaration isn't a
prototype
drivers/scsi/scsi_proc.c:85: conflicting types for `down'
include/asm/semaphore.h:115: previous declaration of `down'
drivers/scsi/scsi_proc.c:85: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:95: parse error before '&' token
drivers/scsi/scsi_proc.c:95: warning: type defaults to `int' in
declaration of `up'
drivers/scsi/scsi_proc.c:95: warning: function declaration isn't a
prototype
drivers/scsi/scsi_proc.c:95: conflicting types for `up'
include/asm/semaphore.h:197: previous declaration of `up'
drivers/scsi/scsi_proc.c:95: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:103: parse error before '&' token
drivers/scsi/scsi_proc.c:103: warning: type defaults to `int' in
declaration of `down'
drivers/scsi/scsi_proc.c:103: warning: function declaration isn't a
prototype
drivers/scsi/scsi_proc.c:103: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:108: parse error before '&' token
drivers/scsi/scsi_proc.c:108: warning: type defaults to `int' in
declaration of `up'
drivers/scsi/scsi_proc.c:108: warning: function declaration isn't a
prototype
drivers/scsi/scsi_proc.c:108: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:117: parse error before "if"
drivers/scsi/scsi_proc.c:120: parse error before string constant
drivers/scsi/scsi_proc.c:120: warning: type defaults to `int' in
declaration of `sprintf'
drivers/scsi/scsi_proc.c:120: warning: function declaration isn't a
prototype
drivers/scsi/scsi_proc.c:120: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:121: warning: type defaults to `int' in
declaration of `p'
drivers/scsi/scsi_proc.c:121: conflicting types for `p'
drivers/scsi/scsi_proc.c:114: previous declaration of `p'
drivers/scsi/scsi_proc.c:122: `sht' undeclared here (not in a function)
drivers/scsi/scsi_proc.c:122: `shost' undeclared here (not in a
function)
drivers/scsi/scsi_proc.c:122: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:123: parse error before "if"
drivers/scsi/scsi_proc.c:141: parse error before string constant
drivers/scsi/scsi_proc.c:141: warning: type defaults to `int' in
declaration of `sprintf'
drivers/scsi/scsi_proc.c:141: warning: function declaration isn't a
prototype
drivers/scsi/scsi_proc.c:141: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:142: parse error before '->' token
drivers/scsi/scsi_proc.c:142: warning: type defaults to `int' in
declaration of `remove_proc_entry'
drivers/scsi/scsi_proc.c:142: warning: function declaration isn't a
prototype
drivers/scsi/scsi_proc.c:142: conflicting types for `remove_proc_entry'
include/linux/proc_fs.h:101: previous declaration of `remove_proc_entry'
drivers/scsi/scsi_proc.c:142: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:313:33: macro "scsi_init_procfs" passed 1
arguments, but takes just 0
drivers/scsi/scsi_proc.c:314: syntax error before '{' token
drivers/scsi/scsi_proc.c:317: warning: type defaults to `int' in
declaration of `proc_scsi'
drivers/scsi/scsi_proc.c:317: conflicting types for `proc_scsi'
drivers/scsi/scsi_proc.c:40: previous declaration of `proc_scsi'
drivers/scsi/scsi_proc.c:317: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:318: parse error before "if"
drivers/scsi/scsi_proc.c:321: warning: type defaults to `int' in
declaration of `pde'
drivers/scsi/scsi_proc.c:321: warning: initialization makes integer from
pointer without a cast
drivers/scsi/scsi_proc.c:321: initializer element is not constant
drivers/scsi/scsi_proc.c:321: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:322: parse error before "if"
drivers/scsi/scsi_proc.c:334:27: macro "scsi_exit_procfs" passed 1
arguments, but takes just 0
drivers/scsi/scsi_proc.c:335: syntax error before '{' token
drivers/scsi/scsi_proc.c:337: parse error before string constant
drivers/scsi/scsi_proc.c:337: warning: type defaults to `int' in
declaration of `remove_proc_entry'
drivers/scsi/scsi_proc.c:337: warning: function declaration isn't a
prototype
drivers/scsi/scsi_proc.c:337: warning: data definition has no type or
storage class
drivers/scsi/scsi_proc.c:59: warning: `proc_scsi_write_proc' defined but
not used
drivers/scsi/scsi_proc.c:305: warning: `proc_scsi_operations' defined
but not used
make[2]: *** [drivers/scsi/scsi_proc.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2


