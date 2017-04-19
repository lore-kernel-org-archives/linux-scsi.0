From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/2] scsi: storvsc: Add support for FC rport
Date: Wed, 19 Apr 2017 19:14:50 -0400
Message-ID: <yq1inm0rnv9.fsf@oracle.com>
References: <1492454266-24587-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1492454266-24587-1-git-send-email-cavery@redhat.com> (Cathy
 Avery's message of "Mon, 17 Apr 2017 14:37:44 -0400")
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
Cc: sthemmin@microsoft.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, hch@infradead.org, devel@linuxdriverproject.org, jejb@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org


Cathy,

> The updated patch set provides a way for drivers ( specifically
> storvsc in this case ) that expose virturalized fc devices
> but that do not expose rports to be manually scanned. This is
> done via creating a pseudo rport in storvsc and a
> corresponding dummy initiator rport role in the fc transport.

Applied to 4.12/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
