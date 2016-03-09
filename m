From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: storvsc: fix SRB_STATUS_ABORTED handling
Date: Tue, 08 Mar 2016 20:59:30 -0500
Message-ID: <yq1oaaowgvx.fsf@sermon.lab.mkp.net>
References: <1457348384-11869-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1457348384-11869-1-git-send-email-vkuznets@redhat.com> (Vitaly
 Kuznetsov's message of "Mon, 7 Mar 2016 11:59:44 +0100")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, Cathy Avery <cavery@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Vitaly" == Vitaly Kuznetsov <vkuznets@redhat.com> writes:

Vitaly> Commit 3209f9d780d1 ("scsi: storvsc: Fix a bug in the handling
Vitaly> of SRB status flags") filtered SRB_STATUS_AUTOSENSE_VALID out
Vitaly> effectively making the (SRB_STATUS_ABORTED |
Vitaly> SRB_STATUS_AUTOSENSE_VALID) case a dead code. The logic from
Vitaly> this branch (e.g. storvsc_device_scan() call) is still required,
Vitaly> fix the check.

Applied to 4.5/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
