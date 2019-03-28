From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/4] ibmvfc: Remove "failed" from logged errors
Date: Wed, 27 Mar 2019 21:35:11 -0400
Message-ID: <yq1bm1vvl0w.fsf@oracle.com>
References: <20190320195654.4364-1-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20190320195654.4364-1-tyreld@linux.vnet.ibm.com> (Tyrel
 Datwyler's message of "Wed, 20 Mar 2019 14:56:51 -0500")
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
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, brking@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org


Tyrel,

> The text of messages logged with ibmvfc_log_error() always contain the
> term "failed". In the case of cancelled commands during EH they are
> reported back by the VIOS using error codes. This can be confusing to
> somebody looking at these log messages as to whether a command was
> successfully cancelled. The following real log message for example it
> is unclear if the transaction was actaully cancelled.

Applied to 5.1/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
