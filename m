From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH 2/2] scsi: storvsc: Add support for FC lightweight host.
Date: Mon, 23 Jan 2017 11:13:11 +0800
Message-ID: <20170123031311.GB12419@lemon.Home>
References: <1484771338-8903-1-git-send-email-cavery@redhat.com>
 <1484771338-8903-3-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1484771338-8903-3-git-send-email-cavery@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Cathy Avery <cavery@redhat.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 01/18 15:28, Cathy Avery wrote:
> Enable FC lightweight host option so that the luns exposed by
> the driver may be manually scanned.

Hi Cathy, out of curiosity: how does this relate to issue_lip operation? And how
to trigger manual scan with this patch?

Fam
