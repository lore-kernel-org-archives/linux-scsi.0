From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/38] cxlflash: OCXL transport support
Date: Tue, 06 Mar 2018 13:01:54 -0500
Message-ID: <yq18tb5rskt.fsf@oracle.com>
References: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 (Uma Krishnan's message of "Mon, 26 Feb 2018 16:18:33 -0600")
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


> This patch series adds OCXL support to the cxlflash driver. With this
> support, new devices using the OCXL transport will be supported by the
> cxlflash driver along with the existing CXL devices. An effort is made
> to keep this transport specific function independent of the existing
> core driver that communicates with the AFU.

This one has been sitting for a week without any reviews. Andrew, when
will you have time to take a look?

Being a pretty big chunk of code, I would like to merge it sooner rather
than later. Or we can postpone until 4.18, of course.

-- 
Martin K. Petersen	Oracle Linux Engineering
