From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Tue, 22 May 2018 17:42:06 -0600
Message-ID: <9A0BC289-4203-4C77-A012-AAB07F42061F@kernel.dk>
References: <20180522181512.39316-1-keescook@chromium.org> <20180522181512.39316-4-keescook@chromium.org> <20180522183613.GA3784@infradead.org> <yq1efi3bk3g.fsf@oracle.com> <CAGXu5jJ0Sice+fdpWgzBhQR=NGz-DT9qmYVdV1GeH73_q9pbmw@mail.gmail.com> <732f4249-5681-4a54-ec21-4ecc3d3a74e5@kernel.dk> <20180522191309.GA23615@infradead.org> <8d4af5c4-96fa-54ee-d5c1-b887b1de5a3c@kernel.dk> <CAGXu5j+mgGZkTDS6EDRspJKKbU=vMT4ehv9T-SekPba=ESoGDg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+mgGZkTDS6EDRspJKKbU=vMT4ehv9T-SekPba=ESoGDg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On May 22, 2018, at 5:31 PM, Kees Cook <keescook@chromium.org> wrote:
>=20
>> On Tue, May 22, 2018 at 12:16 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 5/22/18 1:13 PM, Christoph Hellwig wrote:
>>>> On Tue, May 22, 2018 at 01:09:41PM -0600, Jens Axboe wrote:
>>>> I think Martin and Christoph are objecting to moving the code to
>>>> block/scsi_ioctl.h. I don't care too much about where the code is, but
>>>> think it would be nice to have the definitions in a separate header. Bu=
t
>>>> if they prefer just pulling in all of SCSI for it, well then I guess
>>>> it's pointless to move the header bits. Seems very heavy handed to me,
>>>> though.
>>>=20
>>> It might be heavy handed for the 3 remaining users of drivers/ide,
>>=20
>> Brutal :-)
>=20
> Heh. I noticed a similar sense buffer use in drivers/cdrom/cdrom.c
> too. Is this okay under the same considerations?

This is going from somewhat crazy to pretty nuts, imho. I guess in practical=
 terms it doesn=E2=80=99t matter that much, since most folks would be using s=
r. I still think a split would be vastly superior. Just keep the scsi code i=
n drivers/scsi/ and make it independently selectable.

Jens
