From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 00/41] cxlflash: OCXL transport support and
 miscellaneous fixes
Date: Wed, 28 Mar 2018 17:34:31 -0400
Message-ID: <yq1o9j7j34o.fsf@oracle.com>
References: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 (Uma Krishnan's message of "Mon, 26 Mar 2018 11:29:19 -0500")
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
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org


Uma,

> This patch series adds OCXL support to the cxlflash driver. With this
> support, new devices using the OCXL transport will be supported by the
> cxlflash driver along with the existing CXL devices. An effort is made
> to keep this transport specific function independent of the existing
> core driver that communicates with the AFU.
>
> The first three patches contain a minor fix and staging improvements.
>
> This series is intended for 4.17 and is bisectable.

Something this big really needs to be submitted around rc2/rc3. It's way
too late in the cycle to ensure proper zeroday coverage for all these
commits.

I have started a 4.18/scsi-queue branch to hold this series for now.
The 4.18 branch will be rebased once 4.17rc1 is out in a few weeks. Your
changes won't show up in for-next until then either.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
