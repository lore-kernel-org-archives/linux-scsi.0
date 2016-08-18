From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/6] cxlflash: Add kref to context
Date: Thu, 18 Aug 2016 13:38:41 -0500
Message-ID: <7f1b0544-9ae9-e45e-c476-e46c0fb077d4@linux.vnet.ibm.com>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1470785982-9233-1-git-send-email-mrochs@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1470785982-9233-1-git-send-email-mrochs@linux.vnet.ibm.com>
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
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Christophe Lombard <clombard@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

Acked-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

On 8/9/2016 6:39 PM, Matthew R. Ochs wrote:
> Currently, context user references are tracked via the list of LUNs
> that have attached to the context. While convenient, this is not
> intuitive without a deep study of the code and is inconsistent with
> the existing reference tracking patterns within the kernel. This design
> choice can lead to future bug injection.
>
> To improve code comprehension and better protect against future bugs, add
> explicit reference counting to contexts and migrate the context removal
> code to the kref release handler.
>
> Inspired-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
