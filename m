From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH v3 13/13] cxgbit: add files for cxgbit.ko
Date: Tue, 12 Jul 2016 10:53:10 +0300
Message-ID: <CAJ3xEMhyzVEq4u+3q-HCK4iOg_H5LHjay7_4LVVYZ3Ppbc2voA@mail.gmail.com>
References: <CAJ3xEMgtsPiatZ-Cy2ENsGVyKVDQSSHi4jr0Ushg21JiuqdLcw@mail.gmail.com>
 <1464072025.22249.87.camel@haakon3.risingtidesystems.com> <CAJ3xEMjE3pfz7+QKMUheH9P+xyvj81qbCtbod0mBi7pUspMRXg@mail.gmail.com>
 <011401d1b6ac$917ea000$b47be000$@opengridcomputing.com> <CAJ3xEMhm4eemgvgbpCEKc86LbKSi3WKUX7d+57KwwtZbJB52Wg@mail.gmail.com>
 <1464238504.22249.168.camel@haakon3.risingtidesystems.com>
 <20160526185819.GA1672@chelsio.com> <CAJ3xEMgdx5uFdwgdhoAXBFK6dCN59xLH0bta2j3DxMGZ31Fbsg@mail.gmail.com>
 <20160706171703.GA1685@chelsio.com> <CAJ3xEMhnmcJHrBot4yiz6obS9a8rHOZVNP-EfQHCAFbJhFMcZg@mail.gmail.com>
 <20160708180354.GA1658@chelsio.com> <00fc01d1d947$9a76aff0$cf640fd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <00fc01d1d947$9a76aff0$cf640fd0$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Varun Prakash <varun@chelsio.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 8, 2016 at 9:36 PM, Steve Wise <swise@opengridcomputing.com> wrote:
>> > > In first series libcxgb.ko will have common
>> > > iSCSI DDP Page Pod Manager that will be shared
>> > > by three Chelsio iSCSI drivers
>> > > cxgb3i, cxgb4i, cxgbit.
>> >
>> > cool
>> >
>> > > In subsequent series I will add common connection
>> > > management and other hardware specific common code
>> > > in this module.
>> >
>> > any chance to get that ready for 4.8 too?
>>
>> I am working on common connection management, it is a
>> big change as it involves multiple modules, so it is
>> difficult to get it ready for 4.8.
>
> Let's shoot for 4.9 for the common CM.  Nice work on the PPOD unification!


Taking into account that this was a reviewer comment that basically
should have been addressed for
the initial merge into 4.7 and that there's more time for 4.8 work
[1], could you try and get that for 4.8?

[1] https://lwn.net/Articles/694055/
