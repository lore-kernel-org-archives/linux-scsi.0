From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: PATCH: Further aacraid work
Date: Thu, 17 Jun 2004 13:54:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2407B@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:8351 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261239AbUFQRym convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 13:54:42 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>, Clay Haapala <chaapala@cisco.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

And I might add, undoing the entropy to result in the descending page
list (but that is the forth time I've said this).

I ran heavy sequential load overnight and continued to have this
characteristic when taking snapshots of command SG lists. The average SG
element size statistically was 4168 bytes.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Alan Cox [mailto:alan@redhat.com] 
Sent: Thursday, June 17, 2004 12:47 PM
To: Clay Haapala
Cc: James Bottomley; Salyzyn, Mark; Christoph Hellwig; Alan Cox; Linux
Kernel; SCSI Mailing List
Subject: Re: PATCH: Further aacraid work

On Thu, Jun 17, 2004 at 11:32:29AM -0500, Clay Haapala wrote:
> So, on regular x86 this is a matter of convenience/timing, and the
> page assignments will tend toward, but not always be, random 1-page
> entries as the system is used.

In 2.4 at least it shows no sign of degenerating in that way, something
in the VM is undoing the entropy

