From: devzero@web.de
Subject: Re: Disable SCSI-Reservation at the driver level ?
Date: Mon, 27 Nov 2006 19:36:52 +0100
Message-ID: <1457202469@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate09.web.de ([217.72.192.184]:2004 "EHLO
	fmmailgate09.web.de") by vger.kernel.org with ESMTP id S933061AbWK0Sgy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 13:36:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Hi !

> It's a modified linux kernel with hooks for a big binary module that =
takes
> over part of the control.  It's rather hard to argue that it's not a =
derived
> work.  Especially as they reuse various I/O subsystem of the kernel
> that has been parasited.


They have put their modified sources for download at http://www.vmware.=
com/download/vi/open_source.html

=46or recent version of ESX this is  http://download3.vmware.com/softwa=
re/vi/VMware-esx-public-source-3.0.1-32039.tar.gz

which is:

VMware-esx-drivers-public-source-3.0.1-32039.tar.gz
VMware-esx-gpl-public-source-3.0.1-32039.tar.gz
VMware-esx-server-public-source-3.0.1-32039.tar.gz


which is:
# ls -la VMware-esx-drivers-public-source-3.0.1-32039/src/drivers/* |wc=
 -l
41

# ls -la VMware-esx-public-source-3.0.1-32039=20
total 54
drwxr-xr-x   11 root root   360 Sep 27 01:51 .
drwxrwxrwt  188 root root 23896 Nov 27 19:18 ..
-r--r--r--    1 root root 18003 Sep 27 01:51 COPYING
-r--r--r--    1 root root   832 Sep 27 01:51 README
drwxr-xr-x    2 root root  3656 Sep 27 01:51 include
drwxr-xr-x    4 root root   120 Sep 27 01:51 installer
drwxr-xr-x    2 root root  2144 Sep 27 01:51 linux-iscsi
drwxr-xr-x    2 root root    88 Sep 27 01:51 pixops-2.0
drwxr-xr-x    2 root root   136 Sep 27 01:51 ramcheck
drwxr-xr-x    2 root root    88 Sep 27 01:51 uwglibc-2.2.5
drwxr-xr-x    2 root root  1008 Sep 27 01:51 vmkiscsi-util
drwxr-xr-x    2 root root   624 Sep 27 01:51 vmklinux
drwxr-xr-x    2 root root   128 Sep 27 01:51 vmkload_mod

# tar tzvf VMware-esx-gpl-public-source-3.0.1-32039.tar.gz
booty-0.31.1-5.src.rpm
busybox-0.60.5-11.src.rpm
initscripts-7.31.30.EL-13vmw.src.rpm
iputils-20020927-11.30.4vmw.src.rpm
kudzu-1.1.22.14-4.1.4.src.rpm
mingetty-1.06-2vmw.src.rpm
mkinitrd-3.5.13-16.src.rpm
openssh-3.6.1p2-33.30.9vmw.src.rpm
pam_passwdqc-1.0.2-1.src.rpm
parted-1.6.3-48vmw.src.rpm
pixops-2.0.tar.gz
procmail-3.22-10vmw.src.rpm
redhat-config-keyboard-1.1.4-2.src.rpm
rhpl-0.110.6-2.src.rpm
rpm-4.2.3-26vmw.src.rpm
samba-3.0.9-1.3E.10vmw.src.rpm
shadow-utils-4.0.3-22.03.src.rpm
util-linux-2.11y-31.12vmw.src.rpm
util-linux-2.11y-31.14vmw.src.rpm
vmware-hwdata-1.00-6vmw.src.rpm
vmware-release-3-3vmw.src.rpm
yum-2.0.7-3vmw.src.rpm


So they have re-distributed the sources of all kernel-code/tools they h=
ave modified for their product.

I cannot judge, if this is really complete download or if there is miss=
ing some or some thousands of lines, but if there is no proof that ther=
e is missing a line, i don`t really understand why there is any issue w=
ith this.

The GPL allows modification and even sale of  GPL`ed protected code or.=
 It just enforces derived code being GPL`ed, too.

Ok, maybe half of their product is standing on the shoulders of giants =
(i.e kernel hackers and not people working for vmware) and they don`t t=
ell everyone - but this is the same with half of the world`s DSL-router=
s.

i`m not sure, but do you just mean:

"they take everything from us, making millions of dollars, but they don=
`t give anything (real) back to us because the modified sources are mor=
e or less useless for the rest of the world...."

???
=20
Hey, come on - even if you are right with this - all i wanted to know i=
s how to modify their product so it works for me as i want it to work. =
That`s why i like freedom of open-source and why i dislike closed-sourc=
e. I`d happily switch to XEN, but unfortunately XEN is no option for no=
w....

Am i sort of a traitor now , becoming ostracized ?

roland





> -----Urspr=FCngliche Nachricht-----
> Von: Christoph Hellwig <hch@infradead.org>
> Gesendet: 27.11.06 18:19:24
> An: devzero@web.de
> CC: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org
> Betreff: Re: Disable SCSI-Reservation at the driver level ?


> On Mon, Nov 27, 2006 at 10:45:42AM +0100, devzero@web.de wrote:
> > > And more.  It's in fact one of the most blatant violations of the
> > > Linux 2.4 kernel copyrights.  Don't expect support if you use suc=
h
> > > an illegal product.
> >=20
> > really?
> > this is the first time i hear that ESX is an "illegal" product from=
 the point of view of the kernel community.
> > afaik, the esx kernel (vmnix) is a completely different product and=
 for example, the source of the linux drivers they have modified to run=
 under ESX are made available for download, as GPL tells them to do.
> >=20
> > what`s the problem here?
>=20
> It's a modified linux kernel with hooks for a big binary module that =
takes
> over part of the control.  It's rather hard to argue that it's not a =
derived
> work.  Especially as they reuse various I/O subsystem of the kernel
> that has been parasited.
>=20
> > can you provide a link to some thread where this has been discussed=
?
>=20
> I don't think so.
>=20
> > something to be resolved with the help of gpl-violations.org ?
>=20
> I haven't found any evidence that they are using enough code that
> gpl-violations.org has the right to defend.
>=20


_______________________________________________________________________=
_______
"Ein Herz f=FCr Kinder" - Ihre Spende hilft! Aktion: www.deutschlandseg=
elt.de
Unser Dankesch=F6n: Ihr Name auf dem Segel der 1. deutschen America's C=
up-Yacht!

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
