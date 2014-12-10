From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Date: Wed, 10 Dec 2014 20:57:46 +0000
Message-ID: <20141210205746.GB1209@sucs.org>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1418200705-488-1-git-send-email-longli@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Long Li <longli@microsoft.com>
Cc: linux-scsi@vger.kernel.org, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 10, 2014 at 12:38:25AM -0800, Long Li wrote:
> MSFT targets currently claim SPC-2 compliance while they implement
> post SPC-2 features. With this patch we can correctly handle
> WRITE_SAME_16 issues.
> 
> This patch fixes an issue where the flag is setup too late in drive
> initialization process.

Li, is this a fix for the issue I keep whinging about over in
https://lkml.org/lkml/2014/10/21/23 ?

If is the same issue you may want to CC Martin on this...

-- 
Sitsofe | http://sucs.org/~sits/
