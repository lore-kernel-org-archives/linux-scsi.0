From: Cathy Avery <cavery@redhat.com>
Subject: Re: [PATCH 2/2] scsi: storvsc: Add support for FC lightweight host.
Date: Mon, 23 Jan 2017 15:55:34 -0500
Message-ID: <58866DC6.1080203@redhat.com>
References: <1484771338-8903-1-git-send-email-cavery@redhat.com>
 <1484771338-8903-3-git-send-email-cavery@redhat.com>
 <20170123031311.GB12419@lemon.Home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170123031311.GB12419@lemon.Home>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Fam Zheng <famz@redhat.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

Hi,

There is no way to issue a lip directly as  the current client for this 
feature ( storvsc ) does not handle that request as a physical fc hba 
can. Storvsc only has two fc attributes exposed -  port_name and node_name.

You can rescan the bus with the standard echo "- - -" > 
/sys/class/scsi_host/hostX/scan.

Cathy


On 01/22/2017 10:13 PM, Fam Zheng wrote:
> On Wed, 01/18 15:28, Cathy Avery wrote:
>> Enable FC lightweight host option so that the luns exposed by
>> the driver may be manually scanned.
> Hi Cathy, out of curiosity: how does this relate to issue_lip operation? And how
> to trigger manual scan with this patch?
>
> Fam
