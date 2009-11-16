From: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: FC bus questions
Date: Mon, 16 Nov 2009 10:44:13 -0800
Message-ID: <1258397053.3331.10149.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi James (and everyone else),

   I wanted to continue the discussion on FCoE statistics and a possible
device tree reorganization. The original thread has been expired from my
mail system, so I have to start this new thread. The main theme was that
we might want to convert FC to be a bus.

   For reference here is your proposed sysfs layout-

/sys/.../fcportX/fcfportY/fcfabricZ/fcvportA/fcrportB
                                            /fcpinitC/hostD/target<H:C:T>/<H:C:T>

   I can see a benefit to extending the FC device tree. Assuming that
each of these devices is created as they're discovered by the FC HBA
then it's giving a more accurate description of the system's state. For
example, in FCoE if you were to succeed with FIP and discover a FCF, but
the FLOGI failed then user space could clearly see that devices were
only created up to the fcfabric. I also think that it simply makes more
room for new attributes. With FCFs and FCoE attributes it would be nice
to have them better organized instead of just grouping them all under
the fc_host.

   Aside from a sysfs reorganization, which could be done without making
FC a bus, the main benefit seems to be that other FC4 protocols could
use a FC HBA. Is there other goodness that I'm overlooking?

   Also, buses usually have devices and drivers. I'm not sure what the
FC drivers would be since SCSI would ultimately provide the drivers for
SCSI-FCP. Would a FC bus only have devices and no drivers?

Thanks, //Rob
