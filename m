From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] ata: fixes kernel crash while tracing
 ata_eh_link_autopsy event
Date: Fri, 3 Nov 2017 06:28:26 -0700
Message-ID: <20171103132826.GR3252168@devbig577.frc2.facebook.com>
References: <1509620467-6679-1-git-send-email-rsahu@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509620467-6679-1-git-send-email-rsahu@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Rameshwar Prasad Sahu <rsahu@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 02, 2017 at 04:31:07PM +0530, Rameshwar Prasad Sahu wrote:
> When tracing ata link error event, the kernel crashes when the disk is
> removed due to NULL pointer access by trace_ata_eh_link_autopsy API.
> This occurs as the dev is NULL when the disk disappeared. This patch
> fixes this crash by calling trace_ata_eh_link_autopsy only if "dev"
> is not NULL.
> 
> v2 changes:
>  Removed direct passing "link" pointer instead of "dev" in trace API.
> 
> Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>

Applied to libata/for-4.15.

Thanks.

-- 
tejun
