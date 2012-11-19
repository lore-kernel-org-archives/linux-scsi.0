From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 05/10] libata: separate ATAPI code
Date: Mon, 19 Nov 2012 06:51:11 -0800
Message-ID: <20121119145111.GB15971@htj.dyndns.org>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <1352443922-13734-6-git-send-email-aaron.lu@intel.com>
 <20121112185710.GD5560@mtj.dyndns.org>
 <20121113124923.GA11672@aaronlu.sh.intel.com>
 <20121118150117.GK7306@mtj.dyndns.org>
 <50A9979B.1040309@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50A9979B.1040309@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 19, 2012 at 10:21:15AM +0800, Aaron Lu wrote:
> My thought is that, the 2 functions are for ATAPI and can be used by
> libata-eh, libata-zpodd and maybe others in the future, so it deserves
> a separate place. But if this is regarded as unnecessary, I will drop
> this patch.

Yeah, please drop.  There are a lot of function in libata-core and eh
which are used all over libata.  No need to move them because they're
gonna be used somewhere else.

Thanks.

-- 
tejun
