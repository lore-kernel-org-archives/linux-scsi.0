From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/6] cxlflash: Transition to application close model
Date: Tue, 23 Aug 2016 22:25:17 -0400
Message-ID: <yq1d1kyewdu.fsf@sermon.lab.mkp.net>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1470785992-9274-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1470785992-9274-1-git-send-email-mrochs@linux.vnet.ibm.com>
 (Matthew R. Ochs's message of "Tue, 9 Aug 2016 18:39:52 -0500")
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

Matthew> Caching the adapter file descriptor and performing a close on
Matthew> behalf of an application is a poor design. This is due to the
Matthew> fact that once a file descriptor in installed, it is free to be
Matthew> altered without the knowledge of the cxlflash driver. This can
Matthew> lead to inconsistencies between the application and
Matthew> kernel. Furthermore, the nature of the former design is more
Matthew> exploitable and thus should be abandoned.

Matthew> To support applications performing a close on the adapter file
Matthew> that is associated with a context, a new flag is introduced to
Matthew> the user API to indicate to applications that they are
Matthew> responsible for the close following the cleanup (detach) of a
Matthew> context. The documentation is also updated to reflect this
Matthew> change in behavior.

Applied patches 4 through 6 to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
