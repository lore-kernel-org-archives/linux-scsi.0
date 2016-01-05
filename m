From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] scsi: mvsas: fix indenting on return error code
Date: Tue, 5 Jan 2016 13:35:36 +0100
Message-ID: <568BB898.8040403@redhat.com>
References: <1451995000-9210-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451995000-9210-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5.1.2016 12:56, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The return code and error return is incorrectly indented which
> may cause some confusion as it appears at first sight to be associated
> with a device not ready error (with missing { } braces) rather than
> a DEV_IS_GONE() failure.
>
> The incorrect indenting was introduced by commit
> 0b15fb1fdfd403726542cb6111bc916b7a9f7fad ("[SCSI] mvsas: add support
> for Task collector mode and fixed relative bugs")
>
> No functional change, just a minor code reformatting clean up.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Tomas
