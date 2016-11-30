From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] [hv] storvsc: Payload buffer incorrectly sized for 32
 bit kernels.
Date: Wed, 30 Nov 2016 11:39:13 -0500
Message-ID: <yq160n4kjm6.fsf@sermon.lab.mkp.net>
References: <1479908793-19872-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1479908793-19872-1-git-send-email-cavery@redhat.com> (Cathy
 Avery's message of "Wed, 23 Nov 2016 08:46:33 -0500")
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

Cathy> On a 32 bit kernel sizeof(void *) is not 64 bits as hv_mpb_array
Cathy> requires. Also the buffer needs to be cleared or the upper bytes
Cathy> will contain junk.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
