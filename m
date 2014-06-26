From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi: pm8001: pm80xx_hwi.c:  Cleaning up variable is
 set more than once
Date: Thu, 26 Jun 2014 10:20:04 +0200
Message-ID: <53ABD7B4.5070804@redhat.com>
References: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <53ABD51C.5050806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53ABD51C.5050806@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Cc: lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/26/2014 10:09 AM, Jack Wang wrote:
> Thanks Rickard,
> 
> From my point of view, looks good, but I'd like to get review from Anand
> (cc-ed).

I would like to add that I noticed that this fields is only set and appears to be never used,
maybe it could be completely removed.

Regards,
Maurizio Lombardi
