From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 2/3] lpfc: fix misleading indentation
Date: Mon, 14 Mar 2016 23:27:31 +0100
Message-ID: <20160314232731.0000404d@localhost>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
	<1457965789-3373916-3-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457965789-3373916-3-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-scsi@vger.kernel.org

Arnd Bergmann wrote:
> gcc-6 complains about the indentation of the lpfc_destroy_vport_work_array()
> call in lpfc_online(), which clearly doesn't look right:
> 
> drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_online':
> drivers/scsi/lpfc/lpfc_init.c:2880:3: warning: statement is indented as if it were guarded by... [-Wmisleading-indentation]
>    lpfc_destroy_vport_work_array(phba, vports);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/lpfc/lpfc_init.c:2863:2: note: ...this 'if' clause, but it is not
>   if (vports != NULL)
>   ^~
> 
> Looking at the patch that introduced this code, it's clear that the
> behavior is correct and the indentation is wrong.
> 
> This fixes the indentation and adds curly braces around the previous
> if() block for clarity, as that is most likely what caused the code
> to be misindented in the first place.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 549e55cd2a1b ("[SCSI] lpfc 8.2.2 : Fix locking around HBA's port_list")
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>
