From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v18 0/4] ata: Add APM X-Gene SoC AHCI SATA host
 controller support
Date: Mon, 17 Mar 2014 15:55:52 -0400
Message-ID: <20140317195552.GC17373@mtj.dyndns.org>
References: <1394841201-29495-1-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1394841201-29495-1-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 14, 2014 at 05:53:17PM -0600, Loc Ho wrote:
> This patch adds support for the APM X-Gene SoC AHCI SATA host controller. In
> order for the host controller to work, the corresponding PHY driver
> musts also be available. Currently, only Gen3 disk is supported with this
> initial version.

Applied 1-4 to libata/for-3.15.

Thanks.

-- 
tejun
