From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 04/38] cxlflash: Introduce OpenCXL backend
Date: Fri, 23 Feb 2018 13:36:37 -0600
Message-ID: <115B47D4-5BB4-45F2-8A7A-3176C9F1EA60@linux.vnet.ibm.com>
References: <1519338010-51782-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1519338163-51928-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <abe97ecd-7162-c812-816d-268321916bff@au1.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <abe97ecd-7162-c812-816d-268321916bff@au1.ibm.com>
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
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org


> On Feb 22, 2018, at 10:28 PM, Andrew Donnellan =
<andrew.donnellan@au1.ibm.com> wrote:
>=20
> On 23/02/18 09:22, Uma Krishnan wrote:
>> Add initial infrastructure to support a new cxlflash transport, =
OpenCXL.
>> Claim a dependency on OpenCXL (OCXL) and add a new file, ocxl_hw.c, =
which
>> will host the backend routines that are specific to OpenCXL.
>> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
>=20
> Is it necessary to depend on OCXL in all cases? IMHO it should be =
possible to build a cxl-only version without ocxl, though I don't feel =
very strongly on this.

I thought through this and did not feel it is necessary to distinguish =
right now. I will look at adding this in the future. Thanks Andrew !=
