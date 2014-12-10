From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Date: Wed, 10 Dec 2014 16:12:32 -0500
Message-ID: <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1418200705-488-1-git-send-email-longli@microsoft.com> (Long Li's
 message of "Wed, 10 Dec 2014 00:38:25 -0800")
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

>>>>> "Long" == Long Li <longli@microsoft.com> writes:

Long> MSFT targets currently claim SPC-2 compliance while they implement
Long> post SPC-2 features. With this patch we can correctly handle
Long> WRITE_SAME_16 issues.

Handle the issues or handle WRITE SAME(10/16)?

+	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES},

Is that version field meaningful or is it safe for us to inquire about
VPD pages without problems on older versions?

-- 
Martin K. Petersen	Oracle Linux Engineering
