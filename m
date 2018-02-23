From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH 00/38] cxlflash: OpenCXL transport support
Date: Fri, 23 Feb 2018 15:13:34 +1100
Message-ID: <2d8f0a69-5fef-d027-1456-1a9088c2333b@au1.ibm.com>
References: <1519338010-51782-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519338010-51782-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Content-Language: en-AU
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
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 23/02/18 09:20, Uma Krishnan wrote:
> This patch series adds OpenCXL support to the cxlflash driver. With
> this support, new devices using the OpenCXL transport will be supported
> by the cxlflash driver along with the existing CXL devices. An effort is
> made to keep this transport specific function independent of the existing
> core driver that communicates with the AFU.

It's "OpenCAPI" for the standard, and "ocxl" for the driver - I'd rather 
not add "OpenCXL" to our already somewhat confusing proliferation of 
names :)

I'll try to review as much of the ocxl-specific stuff as I can get to, 
though I'm a bit busy with the OpenCAPI skiboot work and reviewing the 
libocxl userspace library at the moment.


Andrew

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
