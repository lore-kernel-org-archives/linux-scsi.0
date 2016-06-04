From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: storvsc: Filter out storvsc messages CD-ROM
 medium not present
Date: Sat, 04 Jun 2016 10:33:18 -0400
Message-ID: <yq1inxpqb0x.fsf@sermon.lab.mkp.net>
References: <1464013757-30357-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1464013757-30357-1-git-send-email-cavery@redhat.com> (Cathy
 Avery's message of "Mon, 23 May 2016 10:29:17 -0400")
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

>>>>> "Cathy" == Cathy Avery <cavery@redhat.com> writes:

Cathy> When a virtual scsi DVD device is present with no image file
Cathy> attached the storvsc driver logs all resulting unnecessary sense
Cathy> errors whenever IO is issued to the device.

Tweaked whitespace and applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
