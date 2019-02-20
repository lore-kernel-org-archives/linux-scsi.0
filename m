From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: clean obsolete return values of eh_timed_out
Date: Tue, 19 Feb 2019 16:45:40 -0800
Message-ID: <1550623540.93548.6.camel@acm.org>
References: <1550385027-6217-1-git-send-email-avri.altman@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550385027-6217-1-git-send-email-avri.altman@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <avri.altman@wdc.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2019-02-17 at 08:30 +-0200, Avri Altman wrote:
+AD4 Those are no longer in use since commit 242f9dcb8ba6
+AD4 (+ACI-block: unify request timeout handling+ACI).

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
