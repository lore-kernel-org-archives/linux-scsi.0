From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH: fix crashes with aacraid
Date: Mon, 03 Jan 2005 15:18:53 -0600
Message-ID: <1104787133.5506.64.camel@mulgrave>
References: <1104158617.20952.51.camel@localhost.localdomain>
	 <1104771922.21673.4.camel@markh1.pdx.osdl.net>
	 <1104776060.13297.5.camel@localhost.localdomain>
	 <1104784348.25281.4.camel@markh1.pdx.osdl.net>
	 <1104785563.5506.55.camel@mulgrave>
	 <1104786268.25281.13.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:2728 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261913AbVACVTI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2005 16:19:08 -0500
In-Reply-To: <1104786268.25281.13.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, coughlan@redhat.com

On Mon, 2005-01-03 at 13:04 -0800, Mark Haverkamp wrote:
> Sorry, I didn't mean to imply anything on your part.  I had thought that
> a patch had been submitted and may have just still been in the queue.

That's OK.  I have the patch in the archives.  But usually if I see a
patch for a maintained driver go by, I wait to see what the maintainer
does with it.  Usually they either fold it into their own queue or tell
me to apply it.  If I hear nothing about it, I assume the former.

I'll dig the patch out and put it in the current tree.

James


