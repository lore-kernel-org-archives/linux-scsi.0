From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [v3.16][v3.17][v3.18][ Regression]  scsi: handle flush errors
 properly
Date: Thu, 11 Dec 2014 07:45:20 +0300
Message-ID: <1418273120.8310.20.camel@HansenPartnership.com>
References: <5488C478.9000209@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <5488C478.9000209@canonical.com>
Sender: stable-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: steven@qumulo.com, "Martin K. Petersen" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-12-10 at 17:08 -0500, Joseph Salisbury wrote:
> Hello James,
> 
> A kernel bug report was opened against Ubuntu [0].  After a kernel
> bisect, it was found that reverting the following commit resolved this bug:

If I read this bug report correctly, it's saying a USB attached device
produces an error when doing a "shred" but the same device PCI attached
doesn't.  Presumably shred sends some type of zero length command USB
storage doesn't like.  What is shred actually doing (what commands is it
sending)?

James
