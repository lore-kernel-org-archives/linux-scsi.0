From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] VMW_PVSCSI: Change to update maintainer details (name, email)
Date: Fri, 17 Jun 2016 11:48:30 +1000
Message-ID: <CAGRGNgVK_xMmCQFHhhJ9E1frzTE--ivX1Po19O_qUjgYtuUK7A@mail.gmail.com>
References: <57634CBD.8000402@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57634CBD.8000402@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Gill <jgill@vmware.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, arvindkumar@vmware.com, pv-drivers@vmware.com, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Jim,

On Fri, Jun 17, 2016 at 11:05 AM, Jim Gill <jgill@vmware.com> wrote:
> From 6a076cc00ec12c6f9cba58ee7e4c3dec49e1e7e5 Mon Sep 17 00:00:00 2001
> From: Jim Gill <jgill@vmware.com>
> Date: Thu, 16 Jun 2016 14:10:43 -0700
> Subject: [PATCH] VMW_PVSCSI: Change to update maintainer details (name,
> email)
>
> Signed-off-by: Jim Gill <jgill@vmware.com>
> ---
>  drivers/scsi/vmw_pvscsi.c | 2 +-
>  drivers/scsi/vmw_pvscsi.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index 6164634..4a0d3cd 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -17,7 +17,7 @@
>   * along with this program; if not, write to the Free Software
>   * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
> USA.
>   *
> - * Maintained by: Arvind Kumar <arvindkumar@vmware.com>
> + * Maintained by: Jim Gill <jgill@vmware.com>

Shouldn't you update MAINTAINERs too? And isn't having this
information in these files redundant?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
