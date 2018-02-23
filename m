From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/38] cxlflash: OpenCXL transport support
Date: Fri, 23 Feb 2018 13:38:23 -0600
Message-ID: <F0F5C6BC-8519-43F3-AD70-4380C059D0A8@linux.vnet.ibm.com>
References: <1519338010-51782-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <2d8f0a69-5fef-d027-1456-1a9088c2333b@au1.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <2d8f0a69-5fef-d027-1456-1a9088c2333b@au1.ibm.com>
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


> On Feb 22, 2018, at 10:13 PM, Andrew Donnellan =
<andrew.donnellan@au1.ibm.com> wrote:
>=20
> On 23/02/18 09:20, Uma Krishnan wrote:
>> This patch series adds OpenCXL support to the cxlflash driver. With
>> this support, new devices using the OpenCXL transport will be =
supported
>> by the cxlflash driver along with the existing CXL devices. An effort =
is
>> made to keep this transport specific function independent of the =
existing
>> core driver that communicates with the AFU.
>=20
> It's "OpenCAPI" for the standard, and "ocxl" for the driver - I'd =
rather not add "OpenCXL" to our already somewhat confusing proliferation =
of names :)

I agree. :) I will fix it in V2. Thanks for the feedback.=
