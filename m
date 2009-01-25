From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Sat, 24 Jan 2009 23:22:53 -0500
Message-ID: <170fa0d20901242022s7efedff4p4654811a1c86af70@mail.gmail.com>
References: <D4B83214B57CAC4499F1114D069E451A01A7D765@bunker.inside.abhaisystems.com>
	<1232723057.3250.21.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1232723057.3250.21.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James.Bottomley@hansenpartnership.com
Cc: device-mapper development <dm-devel@redhat.com>, Sudhakar Pannerselvam <sudhakarp@inmage.net>, linux-scsi@vger.kernel.org, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 23, 2009 at 10:04 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2009-01-22 at 22:22 -0800, Sudhakar Pannerselvam wrote:
>> As James mentioned earlier, this is a distribution issue. I had seen
>> this issue with redhat. If you observe redhat distro qlogic drivers,
>> they compile firmware files along with the driver and hence they
>> wouldn't observe this issue when they load through initrd as there is no
>> firmware loading procedure through hotplug interface, whereas if you
>> compile qlogic driver by hand without inbuilt firmware files and using
>> distro's like redhat, you would encounter this issue. This has to be
>> addressed in nash hotplug code.
>
> OK, there is one little wrinkle with Red Hat:  nash is a sort of all in
> one process and it keeps going wrong.  I've opened a few bugs with red
> hat about nash over the years with hotplug issues, which this is, but
> they always ignore them and then close them when the distro goes end of
> life.

FYI, RHEL5 had this specific nash issue; but RedHat fixed it, see:
https://bugzilla.redhat.com/show_bug.cgi?id=235277

> These problems should be going away when Dave Jones finally kills off
> nash in his initrd/boot system rewrite.

Cool, sounds like it will be a nice improvement.

Mike
