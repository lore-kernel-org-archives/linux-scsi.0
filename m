From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 1/1] scsi: storvsc: Fix a build issue reported by
 kbuild test robot
Date: Sat, 05 Mar 2016 17:02:32 -0500
Message-ID: <yq1bn6s4m87.fsf@sermon.lab.mkp.net>
References: <1456537738-26773-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1456537738-26773-1-git-send-email-kys@microsoft.com>
 (K. Y. Srinivasan's message of "Fri, 26 Feb 2016 17:48:58 -0800")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, jasowang@redhat.com, linux-kernel@vger.kernel.org, jbottomley@parallels.com, ohering@suse.com, hch@infradead.org, hare@suse.de, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "kys" == K Y Srinivasan <kys@microsoft.com> writes:

kys> With this commit, the storvsc driver depends on FC
kys> atttributes. Make this dependency explicit.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
