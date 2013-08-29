From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v1.2 1/1] arcmsr: Support Areca new SATA Raid Adapter
 ARC1214/1224/1264/1284
Date: Thu, 29 Aug 2013 07:18:56 -0700
Message-ID: <1377785936.1928.97.camel@joe-AO722>
References: <1377748071.4571.40.camel@CentOS6.4-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377748071.4571.40.camel@CentOS6.4-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching <ching2048@areca.com.tw>
Cc: jejb@kernel.com, thenzl@redhat.com, fengguang.wu@intel.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-08-29 at 11:47 +0800, Ching wrote:
> From: Ching <ching2048@areca.com.tw>
> 
> Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284
> Modify maximum outstanding command number.
> Notify command complete with auto request sense data.
> Fix bug of updating adapter firmware through ioctl(ARCHTTP) interface.
> Fix coding style warning.
> Fix compiling warning.
> Fix ARC188x hardware reset.
> Fix indent coding.

Hi again Ching.

I think it would be better to separate the coding style
warning and indent coding patches from the fixes and
send each line entry above as an individual patch.

> Singed-off-by: Ching <ching2048@areca.com.tw>

Typo here

Signed-off-by:
