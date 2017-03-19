From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v4 00/14] qla2xxx: Bug Fixes and updates for target.
Date: Sat, 18 Mar 2017 17:32:46 -0700
Message-ID: <1489883566.27336.30.camel@haakon3.risingtidesystems.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-03-15 at 09:48 -0700, Himanshu Madhani wrote:
> Hi Nic,
> 
> Please consider this series for inclusion in target-pending.
> 
> This series contains following changes.
> 
> o Fix for the deadlock because of inconsistent lock usage reported by Bart.
> o Added patch to submit non-critical MBX command via IOCB path.
> o Improved T10-DIF/PI handling with target stack.
> o Changed scsi host lookup method.
> o Some minor bug fixes.
> 
> Changes from v3 --> v4
> 
> o Fixed regression repored by Bart in following patch.
> "qla2xxx: Fix delayed response to command for loop mode/direct connect."
> 
> Note: Patch order has been changed as well from last series. This is to
> isolate bug-fixes in front of improvements to narrow down offending patch.
> Let me know if you would prefer me to submit series with same patch order
> as v3.

Thanks for breaking these up to put bug-fixes with stable CC's at the
head of series, followed by the other bug-fixes + improvements.

As-is, I think it's OK to merge the full series for v4.11-rc.

That said, merged to target-pending/master.

Thanks Himanshu & Co.
