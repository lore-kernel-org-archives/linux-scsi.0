From: Roland Dreier <roland@purestorage.com>
Subject: Re: Write same support
Date: Fri, 3 Feb 2012 11:20:19 -0800
Message-ID: <CAL1RGDWp9k0-PdQyhEnLbRPEckmSX+w5SOcnaW=rxzhtdXmbhg@mail.gmail.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:51268 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754625Ab2BCTUk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2012 14:20:40 -0500
Received: by mail-wi0-f172.google.com with SMTP id hm9so3683038wib.31
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2012 11:20:39 -0800 (PST)
In-Reply-To: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com

On Mon, Jan 30, 2012 at 4:31 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> The discovery heuristics is what stopped this patchkit in its tracks
> last year. So I've spent the last few days testing with every exotic
> (i.e. ancient) SCSI device I could find. I'm pretty happy with how it
> works now but it would be great if more people would put it to the test.

I'll give it a try too ... probably mostly from the POV of testing our array's
WRITE SAME implementation ;)

 - R.
