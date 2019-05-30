From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] ibmvscsi: Wire up host_reset() in the drivers
 scsi_host_template
Date: Wed, 29 May 2019 21:32:22 -0400
Message-ID: <yq17ea820d5.fsf@oracle.com>
References: <20190503005058.8768-1-tyreld@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20190503005058.8768-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
 message of "Thu, 2 May 2019 19:50:56 -0500")
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
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, brking@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org


Tyrel,

> Wire up the host_reset function in our driver_template to allow a user
> requested adpater reset via the host_reset sysfs attribute.

Series applied to 5.3/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
