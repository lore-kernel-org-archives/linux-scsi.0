From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid version confusion
Date: Wed, 12 Oct 2005 13:56:02 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01B52042@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:58509 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751485AbVJLR4F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 13:56:05 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Graham <graham@soundclashchampions.com>, linux-scsi@vger.kernel.org

I am confused too ...

1.1.2-lk2 in 2.6.10 is roughly 1.1.4-2322 from the Adaptec Stream in
heritage. 1.1.2-lk2 in 2.6.12 is roughly 1.1.4-2337. By roughly, there
is stuff from 1.1.3 that is still missing due to 'priorities'.

Each tiny individual patches to change the kernel.org driver to bring it
into synchronization with the Adaptec Branch of the driver have never
had an accompanying version change incorporated into them until
recently. The lack of version movement is a direct result of the major
steps we make here to keep the driver stable, and the resultant
multitude of tiny out-of-order patches that are necessary to move those
changes into the kernel.org tree.

Only recently have the 'version' patches made it in. The driver is *now*
1.1.4 in 2.6.14-rc and is now starting to get the 1.1.5 patches pushed
into the pipe. Once those have made it in (no timeframe), we will send a
patch to push the version up to 1.1.5. These patches are mainly
associated with the changes to move to the 'new comm' interface; a major
performance improvement for this line of adapters.

As for latest stable, 1.1.5-2409 is in the hands of Adaptec's technical
support department. Older versions are kept around as they form
certified combinations with specific hardware. The latest version,
however, should always be good to go with *any* legacy hardware. We are
at 1.1.5-2412 right now and supply the latest in my hands on demand.

The driver as released from Adaptec is meant to be universal, and the
latest will compile in anything from 2.4.2 to 2.6.14 through the power
of Makefile and Source ifdef. The '2.6 purity cleansed' version of the
driver is only a dozen patches ahead of the driver in 2.6.14-rc4. I
still stand in awe of the sed script I use to cleans the sources of all
the ifdefs ...

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Graham
Sent: Wednesday, October 12, 2005 1:24 PM
To: linux-scsi@vger.kernel.org
Subject: aacraid version confusion


I'm thoroughly confused about the versioning of the aacraid driver, and
would very much appreciate it if someone could explain to me how it
works.

Firstly, I've found that the source for the aacraid driver differs
vastly between kernels 2.6.8 and 2.6.13, yet both have the driver
labeled as version "1.1.2-lk2".  If the code changed, shouldn't the
version label change?

Secondly, I don't understand what the 1.1.5 line is.  Where is the
source code kept?  Is it actively merged into the mainline kernel
source?  I found version 1.1.5-2326 on adaptec.com, seen talk of
1.1.5-2345 on this list, and found 1.1.5-2392 on dell.com.

Thirdly, what is considered the latest "stable" version?

Thanks in advance,
  Graham


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
