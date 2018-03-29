From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 00/41] cxlflash: OCXL transport support and
 miscellaneous fixes
Date: Thu, 29 Mar 2018 13:35:30 -0500
Message-ID: <CDF15A59-080C-4904-8F28-F79AFD32AF0C@linux.vnet.ibm.com>
References: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <yq1o9j7j34o.fsf@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <yq1o9j7j34o.fsf@oracle.com>
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org



> On Mar 28, 2018, at 4:34 PM, Martin K. Petersen =
<martin.petersen@oracle.com> wrote:
>=20
>=20
> Uma,
>=20
>> This patch series adds OCXL support to the cxlflash driver. With this
>> support, new devices using the OCXL transport will be supported by =
the
>> cxlflash driver along with the existing CXL devices. An effort is =
made
>> to keep this transport specific function independent of the existing
>> core driver that communicates with the AFU.
>>=20
>> The first three patches contain a minor fix and staging improvements.
>>=20
>> This series is intended for 4.17 and is bisectable.
>=20
> Something this big really needs to be submitted around rc2/rc3. It's =
way
> too late in the cycle to ensure proper zeroday coverage for all these
> commits.
>=20
> I have started a 4.18/scsi-queue branch to hold this series for now.
> The 4.18 branch will be rebased once 4.17rc1 is out in a few weeks. =
Your
> changes won't show up in for-next until then either.

I did send the first version of this series just after 4.16rc2 but the =
reviews took a while and the V3 is cutting close unless we do have an =
rc8 for 4.16 :)

I understand what you are saying and agree with you. Thanks for keeping =
me posted.=
