From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/31] SCSI patches for kernel v4.13.
Date: Tue, 23 May 2017 21:55:05 -0600
Message-ID: <28a3029c-b5eb-ca56-f0ef-75600ca1dd6e@kernel.dk>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/23/2017 06:33 PM, Bart Van Assche wrote:
> Hello Martin,
> 
> This patch series consists of the bug fixes I came up with during
> the past two months. Please consider these patches for kernel v4.13.

Ehm, last I checked the block patches hadn't been reviewed/signed-off
by anyone else. We still have that init addition in the hot path for
request initialization, as Christoph pointed out.

So let's hold off on this a bit, at least on the block parts, until
we have things properly signed off.

-- 
Jens Axboe
