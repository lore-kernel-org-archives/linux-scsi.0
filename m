From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: RE: [RFC PATCH 0/19] A kernel-level configfs enabled generic
	target engine for Linux v2.6.32
Date: Mon, 14 Sep 2009 14:06:35 -0700
Message-ID: <1252962395.2067.325.camel@haakon2.linux-iscsi.org>
References: <1252720508.2067.196.camel@haakon2.linux-iscsi.org>
	 <412A05BA40734D4887DBC67661F4330810060F29@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:33692 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753255AbZINVGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2009 17:06:46 -0400
In-Reply-To: <412A05BA40734D4887DBC67661F4330810060F29@EXMAIL.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chetan.Loke@Emulex.Com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hare@suse.de, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, joel.becker@oracle.com, martin.petersen@oracle.com, hch@lst.de, torvalds@linux-foundation.org, stern@rowland.harvard.edu, bharrosh@panasas.com, florian.haas@linbit.com, philipp.reisner@linbit.com

On Mon, 2009-09-14 at 13:12 -0700, Chetan.Loke@Emulex.Com wrote:
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Nicholas A. Bellinger
> > Sent: Friday, September 11, 2009 9:55 PM
> > To: LKML; linux-scsi
> > Cc: Andrew Morton; Greg KH; Douglas Gilbert; James Bottomley; Hannes
> > Reinecke; FUJITA Tomonori; Mike Christie; Joel Becker; Martin K. Petersen;
> > Christoph Hellwig; Linus Torvalds; Alan Stern; Boaz Harrosh; Florian Haas;
> > Philipp Reisner
> > Subject: [RFC PATCH 0/19] A kernel-level configfs enabled generic target
> > engine for Linux v2.6.32
> > 
> > Greetings all,
> > 
> > This is my humble request for review and inclusion of
> > Target_Core_Mod/ConfigFS v3.2 from lio-core-2.6.git code into mainline
> > v2.6.32.  With TCM v3.2, the two major SPC-4 SCSI target mode fabric
> > features that have now been completed: Persistent Reservation APTPL and
> > implict/explict ALUA are the first all optional SPC4 defined feature
> > implementation of PR and ALUA in the Linux OSS target theatre using an
> > upstream user-driven virtual filesystem directory hierarchy structure
> > based on configfs that can be configured in realtime in combination with
> > interpreted userspace code.
> > 
> > Both of these new features are now being used to provide Persistent
> > Reservations
> > across target power loss and asymmetric multipath I/O to both Linux and
> > non-Linux
> > clients.  There is also an optional ALUA transition delay logic that has
> > been
> > included to futher debug and improve existing upstream client side Linux
> > kernel code
> > using TCM v3.2. These patches have been diffed against v2.6.31, and tested
> > on x86
> > 32-bit HVM, x86_64 KVM, and powerpc.
> > 
> > There is cleanup work continuing to make the TCM code to use dprintk(),
> > and some include cleanups, and other minor fixes.  The code has also
> > been run through checkpatch again since the posting in April, and all
> > errors have been removed, with the exception of one ConfigFS macro
> > define triggering a checkpatch false positive.
> > 
> > As with the posting of the TCM v3.0 code earlier in April, I have
> > decided to break up the submissions into the generic target_core_mod
> > piece (this patch series) and then a seperate one that will be appearing
> > in the next days for v3.2 of the LIO-Target iSCSI fabric module.
> > 
> > More Information about Target_Core_Mod/ConfigFS, and PR and ALUA:
> > 
> > http://www.linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS
> > http://www.linux-iscsi.org/index.php/Persistent_Reservations
> > http://www.linux-iscsi.org/index.php/ALUA
> > 
> > The complete v3.x TCM CLI operations set can be found here:
> > 
> > http://www.linux-iscsi.org/index.php/Lio-utils#v3.1_TCM_CLI_operations
> > 
> > Instructions and examples for getting setup:
> > 
> > http://linux-iscsi.org/builds/docs/LIO-3.0-Users_Reference_Manual.pdf
> > http://www.linux-iscsi.org/index.php/Howto#Start_target_core_mod
> > 
> > Constructive comments are welcome,
> > 
> > --nab
> > 
> 
> 
> 
> Any pointers/URLs for the design/arch doc?

Greetings Chetan,

There are various bits and pieces detailing the TCM design on the
linux-iscsi.org wiki, but no definitive design document (aside from the
comments in the code) is available yet.  

I will however be putting together a first draft for this (along with
the user-level stuff) for Documentation/ soon.  Until then, I would be
happy to answer any questions you may have.

--nab 

> 
> 
> Chetan 


