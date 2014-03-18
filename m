From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ata: Fix compiler warning with APM X-Gene host
 controller driver
Date: Tue, 18 Mar 2014 16:06:52 -0400
Message-ID: <20140318200652.GA32357@mtj.dyndns.org>
References: <1395166477-26408-1-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1395166477-26408-1-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 18, 2014 at 12:14:37PM -0600, Loc Ho wrote:
> This patch fixes an compiler warning with APM X-Gene host controller
> driver when compiled with DEBUG enabled.
> 
> Signed-off-by: Loc Ho <lho@apm.com>

Applied to libata/for-3.15.

Thanks.

-- 
tejun
