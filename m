From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 15/32] target: Refer to u32 luns as unpacked_lun
Date: Mon, 16 Dec 2013 13:25:07 -0800
Message-ID: <1387229107.20247.229.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-16-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-16-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> It's clearer to refer to pointers to the struct se_lun as "lun" and the
> actual number itself as "unpacked_lun".
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_device.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 

Applied to target-pending/for-next.

--nab
