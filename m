From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] cxlflash: Improvements and cleanup
Date: Thu, 18 Aug 2016 22:43:22 -0400
Message-ID: <yq1y43th41h.fsf@sermon.lab.mkp.net>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
 (Matthew R. Ochs's message of "Tue, 9 Aug 2016 18:38:08 -0500")
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew R Ochs <mrochs@linux.vnet.ibm.com> writes:

Matthew> This patch set contains various code improvements and cleanups
Matthew> that were inspired by Al Viro upon reviewing the cxlflash
Matthew> driver. The core improvement is that the driver will no longer
Matthew> cache the adapter file descriptor associated with a
Matthew> context. This results in a user API change that is documented
Matthew> alongside the modifications.

Applied patches 1-3 to 4.9/scsi-queue. The remainder await reviews.

Matthew> The series is based upon 4.8-rc1, intended for 4.9, and is
Matthew> bisectable.

Thanks for making that explicit. Makes my life easier!

-- 
Martin K. Petersen	Oracle Linux Engineering
