From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v15 3/3] arm64: Add APM X-Gene SoC AHCI SATA host
 controller DTS entries
Date: Tue, 11 Mar 2014 08:49:43 -0400
Message-ID: <20140311124943.GD11477@htj.dyndns.org>
References: <1394059489-30706-1-git-send-email-lho@apm.com>
 <1394059489-30706-2-git-send-email-lho@apm.com>
 <1394059489-30706-3-git-send-email-lho@apm.com>
 <1394059489-30706-4-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1394059489-30706-4-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 05, 2014 at 03:44:49PM -0700, Loc Ho wrote:
> This patch adds APM X-Gene SoC AHCI SATA host controller DTS entries.

I pulled the phy branch into libata/for-3.15 but this patch fails to
apply.  Can you please regenerate the patches which need to be applied
on top of libata/for-3.15.

Thanks.

-- 
tejun
