From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [GIT PULL] target fixes for v3.10-rc2
Date: Wed, 15 May 2013 23:40:17 -0400
Message-ID: <CAJZOPZK7_VPzcJnc1s9oZVshvGMbm-LDVO-ZoKu63tD1bqcvDg@mail.gmail.com>
References: <1368654607.6899.16.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1368654607.6899.16.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, shlomop@mellanox.com
List-Id: linux-scsi@vger.kernel.org

On Wed, May 15, 2013 at 5:50 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> A handful of fixes + minor changes this time around, along with one
> important >= v3.9 regression fix for IBLOCK backends.  The highlights include:

Hi Nic,

Are you pushing also a patch which would allow to actually test NULL
based RAM target (e.g target backend that does no actual IO)

Or.


> Nicholas Bellinger (5):
>   iscsi-target: Fix NULL pointer dereference in iscsit_send_reject
>   target/rd: Add ramdisk bit for NULLIO operation
>   iscsi-target: Fix typos in RDMAEXTENSIONS macro usage
>   MAINTAINERS: Update target git tree URL
>   target/iblock: Fix WCE=1 + DPOFUA=1 backend WRITE regression
>
> Shlomo Pongratz (1):
>   iscsi-target: Fix processing of OOO commands
