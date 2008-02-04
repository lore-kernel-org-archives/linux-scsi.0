From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] [RFC] sd: make error handling more robust
Date: Mon, 04 Feb 2008 09:34:59 -0500
Message-ID: <47A72293.8050409@cybernetics.com>
References: <668582.37066.qm@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([70.169.137.4]:2637 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYBDOfA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 09:35:00 -0500
In-Reply-To: <668582.37066.qm@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> You then took hunk #2 (2 lines) of the patch I sent
> you and submitted it as your own, and then I acked
> "your" patch.
>   
I _really_ _really_ hope that you don't believe that I am trying to take
credit for your work. If you take another look, my original patch had
the following hunk:

+
+		/* Make sure that bad_lba is one of the sectors that the
+		 * command was trying to access.
+		 */
+		if (bad_lba < start_lba ||
+		    bad_lba >= start_lba + xfer_size / sector_size)
+			goto out;
+


Your response patch had the following hunk:

+		if (bad_lba < start_lba)
+			goto out;


So I don't feel that it was dishonest for me to submit this as "my"
work. If you were offended, then I apologize.

> I think it would've been much clearer if you had
> singled out the problems you were seeing with your
> HW and sent a single problem with a single patch per
> single email.
>
>   
Agreed. Sometimes it is difficult to predict when something that seems
so straightforward will generate so much controversy.

Tony

