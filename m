From: <Dave.Carroll@microchip.com>
Subject: RE: [PATCH 2/2] scsi: aacraid: change event_wait to a completion
Date: Tue, 11 Dec 2018 16:29:41 +0000
Message-ID: <BYAPR11MB3447E4D0D93323738690993088A60@BYAPR11MB3447.namprd11.prod.outlook.com>
References: <20181210213301.1065510-1-arnd@arndb.de>
 <20181210213301.1065510-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181210213301.1065510-2-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, aacraid@microsemi.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: RaghavaAditya.Renukunta@microsemi.com, prasad.munirathnam@microsemi.com, david.carroll@microsemi.com, dan.carpenter@oracle.com, jthumshirn@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Arnd Bergmann
> Sent: Monday, December 10, 2018 1:33 PM
> To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>; James E.J.
> Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: Arnd Bergmann <arnd@arndb.de>; Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>; Prasad B Munirathnam
> <prasad.munirathnam@microsemi.com>; Dave Carroll
> <david.carroll@microsemi.com>; Dan Carpenter
> <dan.carpenter@oracle.com>; Johannes Thumshirn <jthumshirn@suse.de>;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 2/2] scsi: aacraid: change event_wait to a completion
>=20
> The event_wait semaphore has completion semantics, so we can change it
> over to the completion interface for clarity without changing the behavio=
r.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
