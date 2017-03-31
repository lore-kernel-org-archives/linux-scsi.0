From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 0/3] Improve block device testing coverage
Date: Fri, 31 Mar 2017 15:11:28 +0000
Message-ID: <1490973067.2587.1.camel@sandisk.com>
References: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org>
         <20170331065702.GA17435@infradead.org> <8760ip28o8.fsf@dmlp.sw.ru>
         <20170331093801.GK22845@eguan.usersys.redhat.com>
         <8737dt228x.fsf@dmlp.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <8737dt228x.fsf@dmlp.sw.ru>
Content-Language: en-US
Content-ID: <8F5FC0F26D4015478AAA74E87F206F83@sandisk.com>
Sender: fstests-owner@vger.kernel.org
To: "eguan@redhat.com" <eguan@redhat.com>, "dmonakhov@openvz.org" <dmonakhov@openvz.org>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-03-31 at 13:02 +0300, Dmitry Monakhov wrote:
> Another good example may be a bug with dirty page cache after blkdiscard
> https://lkml.org/lkml/2017/3/22/789 . This simple bug  result in crappy
> fsimage if mkfs relay on discard_zeroes_data behaviour.
> So IMHO basic blkdev test coverage is important filesystem testing. i.e.
> important for xfstests.

Mixing up filesystem tests and block layer / block driver tests in the same
directory is completely wrong. Block driver developers will be primarily
interested in the block tests and may want to skip the filesystem tests.
Filesystem developers will probably run the block tests only once and will
likely run the filesystem tests repeatedly. Mixing up different kinds of
tests in the same directory makes it unnecessarily hard to run block and
filesystem tests separately.

Bart.=
