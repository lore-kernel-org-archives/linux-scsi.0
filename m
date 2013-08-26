From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] arcmsr: Fix bug of updating adapter firmware
 through ioctl(ARCHTTP) interface
Date: Mon, 26 Aug 2013 14:20:23 +0400
Message-ID: <1377512423.20958.7.camel@dabdike>
References: <60A4377E7BEE4B2EA7855F9701B34BF0@chingDT>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <60A4377E7BEE4B2EA7855F9701B34BF0@chingDT>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?=E9=BB=83=E6=B8=85=E9=9A=86?= <ching2048@areca.com.tw>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jejb@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-08-26 at 12:28 +0800, =E9=BB=83=E6=B8=85=E9=9A=86 wrote:
> From: Ching <ching2048@areca.com.tw>
>=20
> Fix bug of updating adapter firmware through ioctl(ARCHTTP) interface=
=2E
> Signed-off-by: Ching <ching2048@areca.com.tw>
> ---

This one has a set of nasty checkpatch errors:

WARNING: please, no spaces at the start of a line
#31: FILE: drivers/scsi/arcmsr/arcmsr.h:801:
+    struct QBUFFER __iomem *);$

ERROR: space prohibited after that open parenthesis '('
#283: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2141:
+       if ( iop_len > 0 ) {

ERROR: space prohibited before that close parenthesis ')'
#283: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2141:
+       if ( iop_len > 0 ) {

ERROR: space prohibited after that open parenthesis '('
#286: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2144:
+               if( buf1 =3D=3D NULL)

ERROR: space required before the open parenthesis '('
#286: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2144:
+               if( buf1 =3D=3D NULL)

ERROR: return is not a function, parentheses are not required
#287: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2145:
+                       return (0);

ERROR: space required before the open parenthesis '('
#293: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2151:
+               if(data_len)

ERROR: space prohibited after that open parenthesis '('
#307: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2165:
+               kfree( (uint8_t *)buf2);

ERROR: return is not a function, parentheses are not required
#310: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2168:
+       return (1);

WARNING: please, no spaces at the start of a line
#315: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2173:
+    struct QBUFFER __iomem *prbuffer) {$

WARNING: braces {} are not necessary for single statement blocks
#321: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2179:
+       if (acb->adapter_type & (ACB_ADAPTER_TYPE_C |
ACB_ADAPTER_TYPE_D)) {
+               return(arcmsr_Read_iop_rqbuffer_in_DWORD(acb,
prbuffer));
+       }

ERROR: return is not a function, parentheses are not required
#322: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2180:
+               return(arcmsr_Read_iop_rqbuffer_in_DWORD(acb,
prbuffer));

ERROR: return is not a function, parentheses are not required
#335: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2193:
+       return (1);

ERROR: need consistent spacing around '-' (ctx:WxV)
#394: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2205:
+       buf_empty_len =3D (acb->rqbuf_lastindex - acb->rqbuf_firstindex
-1) &
                                                                      ^

ERROR: need consistent spacing around '-' (ctx:WxV)
#395: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2206:
+               (ARCMSR_MAX_QBUFFER -1);
                                    ^

ERROR: trailing whitespace
#424: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2224:
+^I$

ERROR: space prohibited after that open parenthesis '('
#428: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2228:
+               if( buf1 =3D=3D NULL)

ERROR: space required before the open parenthesis '('
#428: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2228:
+               if( buf1 =3D=3D NULL)

ERROR: space prohibited after that open parenthesis '('
#557: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2252:
+               kfree( buf1);

ERROR: spaces required around that '=3D' (ctx:VxV)
#568: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2263:
+       int32_t allxfer_len=3D0;
                           ^

ERROR: trailing whitespace
#569: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2264:
+^I$

ERROR: trailing whitespace
#578: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2273:
+^I^Iwhile ((acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) $

ERROR: spaces required around that '=3D' (ctx:VxV)
#759: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2700:
+               for (i=3D0; i < 15; i++) {
                      ^

WARNING: line over 80 characters
#766: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2707:
+                       } else if (acb->rqbuf_firstindex !=3D
acb->rqbuf_lastindex) {

ERROR: trailing whitespace
#770: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2711:
+^I^I^I} else $

WARNING: line over 80 characters
#779: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2766:
+                                       acb->rqbuf_firstindex %=3D
ARCMSR_MAX_QBUFFER;

WARNING: line over 80 characters
#787: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2819:
+               memcpy(pcmdmessagefld->messagedatabuffer, ver_addr,
allxfer_len);

ERROR: space required before the open parenthesis '('
#837: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2824:
+                       if(arcmsr_Read_iop_rqbuffer_data(acb, prbuffer)
=3D=3D 0)

ERROR: spaces required around that '=3D' (ctx:VxV)
#1071: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4279:
+               for (i=3D0; i < 200; i++) {
                      ^

WARNING: msleep < 20ms can sleep for up to 20ms; see
Documentation/timers/timers-howto.txt
+                       msleep(10);
WARNING: line over 80 characters
#1074: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4282:
+                       if (outbound_doorbell &
ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {

ERROR: spaces required around that '=3D' (ctx:VxV)
#1094: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4301:
+               for (i=3D0; i < 200; i++) {
                      ^

WARNING: msleep < 20ms can sleep for up to 20ms; see
Documentation/timers/timers-howto.txt
+                       msleep(10);
WARNING: line over 80 characters
#1097: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4304:
+                       if (outbound_doorbell &
ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK) {

WARNING: quoted string split across lines
#1121: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4750:
+       sprintf(buf, "Areca %s Host Adapter RAID Controller%s\narcmsr "
+               "version %s\n",type, raid6 ? "( RAID6 capable)" : "",

ERROR: space required after that ',' (ctx:VxV)
#1121: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4750:
+               "version %s\n",type, raid6 ? "( RAID6 capable)" : "",
                              ^

total: 25 errors, 11 warnings, 1061 lines checked

Please fix these and resend.

Thanks,

James
