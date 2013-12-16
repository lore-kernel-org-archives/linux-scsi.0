From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 16/32] target: Rename core_tpg_{pre,post}_addlun for
 clarity
Date: Mon, 16 Dec 2013 13:29:03 -0800
Message-ID: <1387229343.20247.230.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-17-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-17-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> "pre" is really an allocation function. The only time it isn't called is
> for virtual_lun0, which is statically allocated. Renaming that to "alloc"
> lets the other function not need to be "post", and just be called
> core_tpg_add_lun.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_device.c   |    4 ++--
>  drivers/target/target_core_internal.h |    4 ++--
>  drivers/target/target_core_tpg.c      |    6 +++---
>  3 files changed, 7 insertions(+), 7 deletions(-)

Applied, with minor patch fuzz in core_tpg_setup_virtual_lun0().

--nab
