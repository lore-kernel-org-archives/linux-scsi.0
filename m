From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] storvsc: add logging for error/warning messages
Date: Thu, 10 Dec 2015 13:12:49 -0500
Message-ID: <yq14mfq2mvy.fsf@sermon.lab.mkp.net>
References: <1449216444-21553-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1449216444-21553-1-git-send-email-longli@microsoft.com> (Long
 Li's message of "Fri, 4 Dec 2015 00:07:24 -0800")
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
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Long" == Long Li <longli@microsoft.com> writes:

Long> Introduce a logging level for storvsc to log certain error/warning
Long> messages. Those messages are helpful in some environments,
Long> e.g. Microsoft Azure, for customer support and troubleshooting
Long> purposes.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
