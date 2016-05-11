From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 5/6] mpt3sas: Set maximum transfer length per IO to 4MB
 for VDs
Date: Wed, 11 May 2016 16:03:06 +0200
Message-ID: <57333B9A.9090006@redhat.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
 <1462525171-6877-6-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462525171-6877-6-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6.5.2016 10:59, Chaitra P B wrote:
> Set maximum transfer length per IO on RAID volumes
> to 4MB by setting VD's queue's max_sector to 8192.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
