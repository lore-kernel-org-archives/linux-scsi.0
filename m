From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2] Target/iser: Fail SCSI WRITE command if device
 detected integrity error
Date: Tue, 18 Mar 2014 22:07:30 -0700
Message-ID: <1395205650.536.5.camel@haakon3.risingtidesystems.com>
References: <1395147507-19035-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1395147507-19035-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, ogerlitz@mellanox.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-03-18 at 14:58 +0200, Sagi Grimberg wrote:
> If during data-transfer a data-integrity error was detected we
> must fail the command with CHECK_CONDITION and not execute
> the command.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Reported-by: Or Gerlitz <ogerlitz@mellanox.com>
> ---
> Changes from v1:
> - Fixed typo
> 
> Changes from v0:
> - Added reported-by Or gerlitz
> 

Applied to for-next.

Thanks Sagi & Or!

--nab
