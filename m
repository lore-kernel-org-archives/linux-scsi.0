From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/7] cxlflash: Isolate external module dependencies
Date: Wed, 16 May 2018 11:13:16 -0500
Message-ID: <20180516161316.GF8754@p8tul1-build.aus.stglabs.ibm.com>
References: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1526065579-39079-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <1526065579-39079-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 11, 2018 at 02:06:19PM -0500, Uma Krishnan wrote:
> Depending on the underlying transport, cxlflash has a dependency on either
> the CXL or OCXL drivers, which are enabled via their Kconfig option.
> Instead of having a module wide dependency on these config options, it is
> better to isolate the object modules that are dependent on the CXL and OCXL
> drivers and adjust the module dependencies accordingly.
> 
> This commit isolates the object files that are dependent on CXL and/or
> OCXL. The cxl/ocxl fops used in the core driver are tucked under an ifdef
> to avoid compilation errors.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
