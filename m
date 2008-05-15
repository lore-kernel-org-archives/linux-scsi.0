From: "Eli Dorfman" <dorfman.eli@gmail.com>
Subject: Re: [ofa-general] iSer and Direct IO
Date: Thu, 15 May 2008 14:23:31 +0300
Message-ID: <694d48600805150423n1a8b0efwf6d6596f8e7891ef@mail.gmail.com>
References: <482B7FE4.9070502@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <482B7FE4.9070502@fusionio.com>
Content-Disposition: inline
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Cameron Harr <charr@fusionio.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, general@lists.openfabrics.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 15, 2008 at 3:12 AM, Cameron Harr <charr@fusionio.com> wrote:
> Hi, I've been trying to compare performances between iSer and srpt and
> am getting mixed results where iSer wins for IOPs and srpt wins for some
> streaming b/w tests. I've tested with iozone, spew and FIO, and IOP
> numbers are always higher on iSer. My problem though is that I'm a
> little suspicious of some of the iSer numbers and whether they are
> really using Direct IO. For example, you'll see below in some of my FIO
> results that I'm getting a write B/W of 799.1 MB/s at one point. That's
> way above what I can get natively on the device (~650 MB/s DIO) and is
> more along the lines of buffered IO. If the IOP numbers are also using
> some kind of caching, that could possibly taint them also. Does anyone
> know if specifying DIO will really bypass all buffers or if something is
> getting cached in the agents (iscsi, tgtd)?
>
>
> FIO
> --------------- iSer 1----iSer 2----SRPT 1----SRPT 2-
> RBW (MB/s)      565.3     836.5     622.0     581.7
> Read IOPs       63488.1   68053.8   5335.6    5446.1
> WBW (MB/s)      799.1     737.7     589.5     594.4
> Write IOPs      79086.6   80005.7   33884.6   34058.6
>
>
> Thanks much,
> Cameron
>

Your question should be posted on linux-scsi.
See the following link that explains about DIO
http://tldp.org/HOWTO/SCSI-Generic-HOWTO/dio.html

Please check with sgp_dd to avoid any caching.

Thanks,
Eli
